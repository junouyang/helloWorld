import argparse
import json
import pymysql.cursors
import requests
import sys
from uuid import uuid4

try:
    # python2
    from urlparse import urlparse
except ImportError:
    # python3
    from urllib.parse import urlparse


def print_border():
    """Prints a border to make the output of this script easier to see."""
    print("=" * 80)


def parse_args(argv=None):
    """Parses the passed in arguments to set up federation with the upstream and downstream accounts.

    The default values are set up as though federation is being set up using a dev controller
    with two accounts (customer1 and customer2).

    Returns:
        A list of values for the known values.
    """
    parser = argparse.ArgumentParser()

    # Controller hosts
    parser.add_argument('--upstream-controller-host', '-h1',
                        default='localhost',
                        help="The hostname of the upstream account's controller.")
    parser.add_argument('--downstream-controller-host', '-h2',
                        default='localhost',
                        help="The hostname of the downstream account's controller.")
    # Controller ports
    parser.add_argument('--upstream-controller-port', '-p1',
                        default='8080',
                        help="The port of the upstream account's controller.")
    parser.add_argument('--downstream-controller-port', '-p2',
                        default='8080',
                        help="The port of the downstream account's controller.")
    # Controller passwords
    parser.add_argument('--upstream-controller-password', '-x1',
                        default='welcome',
                        help="The password to the upstream account.")
    parser.add_argument('--downstream-controller-password', '-x2',
                        default='welcome',
                        help="The password to the downstream account.")
    # Controller protocols
    parser.add_argument('--upstream-controller-protocol', '-s1',
                        default='http',
                        help="The protocol of the upstream controller.")
    parser.add_argument('--downstream-controller-protocol', '-s2',
                        default='http',
                        help="The protocol of the downstream controller.")
    # User names
    parser.add_argument('--upstream-user', '-u1',
                        default='user1',
                        help="The user of the upstream account.")
    parser.add_argument('--downstream-user', '-u2',
                        default='user2',
                        help="The user of the downstream account.")
    # Account names
    parser.add_argument('--upstream-account', '-a1',
                        default='customer1',
                        help="The name of the upstream account name.")
    parser.add_argument('--downstream-account', '-a2',
                        default='customer2',
                        help="The name of the downstream account name.")
    # Database hostnames
    parser.add_argument('--upstream-db-host', '-dh1',
                        default='localhost',
                        help="The hostname of the upstream database.")
    parser.add_argument('--downstream-db-host', '-dh2',
                        default='localhost',
                        help="The hostname of the downstream database.")
    # Database ports
    parser.add_argument('--upstream-db-port', '-dp1',
                        default=3306,
                        type=int,
                        help="The port of the upstream database.")
    parser.add_argument('--downstream-db-port', '-dp2',
                        default=3306,
                        type=int,
                        help="The port of the downstream database.")
    # Database users
    parser.add_argument('--upstream-db-user', '-du1',
                        default='root',
                        help="The user to log into the upstream database.")
    parser.add_argument('--downstream-db-user', '-du2',
                        default='root',
                        help="The user to log into the downstream database.")
    # Database passwords
    parser.add_argument('--upstream-db-password', '-dx1',
                        default='singcontroller',
                        help="The password to the upstream database.")
    parser.add_argument('--downstream-db-password', '-dx2',
                        default='singcontroller',
                        help="The password to the downstream database.")
    # Database names
    parser.add_argument('--upstream-db-name', '-dn1',
                        default='controller',
                        help="The name of the upstream database.")
    parser.add_argument('--downstream-db-name', '-dn2',
                        default='controller',
                        help="The name of the downstream database.")
    args, leftovers = parser.parse_known_args(sys.argv[1:])
    return args


def normalize_hostname(hostname):
    """Normalizes a hostname so that it does not have the protocol (http|https) prepended."""
    url_parts = urlparse(hostname)
    if url_parts.scheme:
        hostname = url_parts.netloc
    return hostname


def generate_uuid(account):
    """Generates a uuid."""
    uuid = str(uuid4())
    # print("Account '{0}' - UUID '{1}'".format(account, uuid))
    return uuid


def get_account_id(controller_url, user, account, password):
    """Retrieve the account id of the controller user.

    Returns:
        Integer if the account is accessible, otherwise exits out.

    """
    login = "{user}@{account}".format(user=user, account=account)
    url = ("{controller_url}/api/accounts/myaccount").format(controller_url=controller_url)
    response = requests.get(url, auth=(login, password), verify=True)
    if response.ok:
        data = json.loads(response.text)
        if len(data):
            return data['id']
    else:
        sys.exit("Failed to find the account id for '{account}'.".format(account))


def get_account_key(host, port, user, password, db_name, account_name):
    """Queries the controller's database to retrieve the an account's account key.

    Returns:
        String if the successful, otherwise exits out.

    """
    connection = pymysql.connect(host=host, port=port, user=user, password=password, db=db_name)
    try:
        with connection.cursor() as cursor:
            # Get the account key for the account.
            cursor.execute("SELECT account_key FROM account WHERE name = '{0}'".format(account_name))
            account_key = cursor.fetchone()[0]
            print("Account '{0}' - Account Key '{1}'".format(account_name, account_key))
            return account_key
    finally:
        connection.close()


def get_accesskey_for_account(account_name, controller_protocol, controller_host, controller_port, user, password):
    response = requests.get(url=controller_protocol + "://" + controller_host + ":" + controller_port + "/controller/auth?action=login",
                            auth=(user, password))

    # print(response.headers)
    set_cookie = response.headers['set-cookie']
    session_id = ''
    csrf_token = ''
    for val in set_cookie.split(';'):
        if val.split('=')[0].endswith('JSESSIONID'):
            session_id = val.split('=')[1]
        if val.split('=')[0].endswith('X-CSRF-TOKEN'):
            csrf_token = val.split('=')[1]

    # print(session_id)
    # print(csrf_token)
    response = requests.get(
        url=controller_protocol + "://" + controller_host + ":" + controller_port + "/controller/restui/admin/accounts",
        headers={
            "Cookie": "JSESSIONID=" + session_id,
            "X-CSRF-TOKEN": csrf_token,
            "Content-Type": "application/json;charset=UTF-8"
        }
    )

    for ac in response.json():
        if ac['name'] == account_name:
            print("Account '{0}' - AccessKey '{1}'".format(account_name, ac['accessKey']))

    return 0


def get_account_api_url(controller_url, password, user, account_name, account_key):
    """Computes a url containing an account's id and key.

    Returns:
        String if successful, or exits while retrieving the account id.

    """
    account_id = get_account_id(controller_url, user, account_name, password)
    return "{0}/api/accounts/{1}/apikey/{2}".format(controller_url,
                                                    account_id,
                                                    account_key)


def get_account_api_key(controller_url, password, user, account_name, uuid):
    """Submits a POST request to retrieve an account's api key.

    Returns:
        String if successful, otherwise exits.
    """
    account_api_url = get_account_api_url(controller_url, password, user, account_name, uuid)
    header = {'Content-Type': 'application/vnd.appd.cntrl+json'}
    payload = '{{"name": "Federation key {0}"}}'.format(uuid)
    request = requests.post(account_api_url,
                            auth=("{0}@{1}".format(user, account_name), password),
                            headers=header,
                            data=payload)
    if not request.ok:
        print(request)
        print(account_api_url)
        print("Failed to create an API Key for '{0}'. Regenerating.".format(account_name))
        regenerate_url = account_api_url + "/secretRegeneration"
        request = requests.post(regenerate_url,
                                auth=("{0}@{1}".format(user, account_name), password),
                                headers=header,
                                data=payload)
        if not request.ok:
            print(request)
            print(regenerate_url)
            sys.exit("Failed to regenerate API Key for '{0}'. Exiting.".format(account_name))
    api_key = request.json()['key']
    print("Account '{0}' - API Key '{1}'".format(account_name, api_key))
    return api_key


def assign_federation_role(controller_url, password, user, account_name, uuid):
    """Submits a PUT request to assign the federation role to the specified account."""
    account_api_url = get_account_api_url(controller_url, password, user, account_name, uuid)
    federation_role_url = account_api_url + "/roles?role-name=Federation%20Administrator"
    request = requests.put(federation_role_url,
                           auth=("{0}@{1}".format(user, account_name), password))
    if not request.ok:
        print(request)
        print(federation_role_url)
        sys.exit("Failed to assign federation role to '{0}'".format(account_name))
    print("Assigned the federation role to '{0}'".format(account_name))


def befriend_account(controller_url, password, account_user, account_name, account_key,
                     friend_controller_url,
                     friend_account_name, friend_account_key, friend_api_key):
    """Submits a POST request to have an account 'befriend' another account."""
    federation_friend_url = "{0}/rest/federation/establishmutualfriendship".format(controller_url)
    header = {'Content-Type': 'application/json'}
    payload = ('{{ '
               '"friendAccountName": "{friend_account_name}", '
               '"friendAccountApiKey": "{friend_api_key}", '
               '"friendAccountControllerUrl": "{friend_controller_url}" }}'.format(
                                                           friend_account_name=friend_account_name,
                                                           friend_api_key=friend_api_key,
                                                           friend_controller_url=friend_controller_url))
    request = requests.post(federation_friend_url,
                            auth=("{0}@{1}".format(account_user, account_name), password),
                            headers=header,
                            data=payload)
    if not request.ok:
        print(request)
        print(federation_friend_url)
        sys.exit("Account '{0}'' failed to befriend '{1}'.".format(account_name, friend_account_name))


def check_friendship_in_db(host, port, user, password, db_name, account_name, account_key,
                           friend_controller_host, friend_controller_port, friend_controller_protocol,
                           friend_account_name, friend_account_key, friend_api_key):
    """Queries the controller's database to see if a friendship row exists with the specified fields."""
    connection = pymysql.connect(host=host, port=port, user=user, password=password, db=db_name)
    try:
        with connection.cursor() as cursor:
            query = ("SELECT * FROM federation_friend_config"
                     " WHERE account_key = '{account_key}'"
                     "   AND friend_controller_host = '{friend_controller_host}'"
                     "   AND friend_controller_port = '{friend_controller_port}'"
                     "   AND friend_controller_protocol = '{friend_controller_protocol}'"
                     "   AND friend_account_key = '{friend_account_key}'"
                     "   AND friend_api_key = '{friend_api_key}'".format(
                account_key=account_key,
                friend_controller_host=friend_controller_host,
                friend_controller_port=friend_controller_port,
                friend_controller_protocol=friend_controller_protocol,
                friend_account_key=friend_account_key,
                friend_api_key=friend_api_key))
            cursor.execute(query)
            if cursor.rowcount == 0:
                print(query)
                sys.exit("Failed to find a friendship in '{0}'s database with '{1}'.".format(
                    account_name, friend_account_name))
            print("'{0}' successfully befriended '{1}'!".format(account_name, friend_account_name))
    finally:
        cursor.fetchall()
        connection.close()


if __name__ == "__main__":
    args = parse_args(sys.argv)

    # Upstream properties
    # Controller properties
    upstream_controller_host = normalize_hostname(args.upstream_controller_host)
    upstream_controller_port = args.upstream_controller_port
    upstream_controller_password = args.upstream_controller_password
    upstream_controller_protocol = args.upstream_controller_protocol
    # Account properties
    upstream_user = args.upstream_user
    upstream_account = args.upstream_account
    # Database properties
    upstream_db_host = args.upstream_db_host
    upstream_db_port = args.upstream_db_port
    upstream_db_user = args.upstream_db_user
    upstream_db_password = args.upstream_db_password
    upstream_db_name = args.upstream_db_name

    # Downstream properties
    # Controller properties
    downstream_controller_host = normalize_hostname(args.downstream_controller_host)
    downstream_controller_port = args.downstream_controller_port
    downstream_controller_password = args.downstream_controller_password
    downstream_controller_protocol = args.downstream_controller_protocol
    # Account properties
    downstream_user = args.downstream_user
    downstream_account = args.downstream_account
    # Database properties
    downstream_db_host = args.downstream_db_host
    downstream_db_port = args.downstream_db_port
    downstream_db_user = args.downstream_db_user
    downstream_db_password = args.downstream_db_password
    downstream_db_name = args.downstream_db_name

    # Create controller urls for both accounts for later usage.
    upstream_controller_url = "{0}://{1}:{2}/controller".format(upstream_controller_protocol,
                                                                upstream_controller_host,
                                                                upstream_controller_port)
    downstream_controller_url = "{0}://{1}:{2}/controller".format(downstream_controller_protocol,
                                                                  downstream_controller_host,
                                                                  downstream_controller_port)

    # Grab the account keys both accounts for later usage.
    upstream_account_key = get_account_key(upstream_db_host, upstream_db_port,
                                           upstream_db_user, upstream_db_password,
                                           upstream_db_name, upstream_account)
    downstream_account_key = get_account_key(downstream_db_host, downstream_db_port,
                                             downstream_db_user, downstream_db_password,
                                             downstream_db_name, downstream_account)
    print_border()

    # Generate a uuid for both accounts, which is used to create an account api key.
    upstream_uuid = generate_uuid(upstream_account)
    downstream_uuid = generate_uuid(downstream_account)
    #print_border()

    # Grab the account api key for both accounts.
    upstream_api_key = get_account_api_key(upstream_controller_url, upstream_controller_password,
                                           upstream_user, upstream_account, upstream_uuid)
    downstream_api_key = get_account_api_key(downstream_controller_url, downstream_controller_password,
                                             downstream_user, downstream_account, downstream_uuid)
    print_border()

    # Assign the federation role to both accounts.
    assign_federation_role(upstream_controller_url, upstream_controller_password,
                           upstream_user, upstream_account, upstream_uuid)
    assign_federation_role(downstream_controller_url, downstream_controller_password,
                           downstream_user, downstream_account, downstream_uuid)
    print_border()

    # Have the upstream and downstream accounts befriend each other.
    befriend_account(downstream_controller_url, upstream_controller_password,
                     upstream_user, upstream_account, upstream_account_key,
                     downstream_controller_url,
                     downstream_account, downstream_account_key, downstream_api_key)
    #befriend_account(downstream_controller_url, downstream_controller_password,
    #                 downstream_user, downstream_account, downstream_account_key,
    #                 upstream_controller_host, upstream_controller_port, upstream_controller_protocol,
    #                 upstream_account, upstream_account_key, upstream_api_key)

    # Double check the controller database.
    check_friendship_in_db(upstream_db_host, upstream_db_port, upstream_db_user, upstream_db_password,
                           upstream_db_name, upstream_account, upstream_account_key,
                           downstream_controller_host, downstream_controller_port, downstream_controller_protocol,
                           downstream_account, downstream_account_key, downstream_api_key)
    #check_friendship_in_db(downstream_db_host, downstream_db_port, downstream_db_user, downstream_db_password,
    #                       downstream_db_name, downstream_account, downstream_account_key,
    #                       upstream_controller_host, upstream_controller_port, upstream_controller_protocol,
    #                       upstream_account, upstream_account_key, upstream_api_key)
    print_border()

    get_accesskey_for_account(upstream_account, upstream_controller_protocol, upstream_controller_host,
                              upstream_controller_port, 'root@system', 'changeme')

    get_accesskey_for_account(downstream_account, downstream_controller_protocol, downstream_controller_host,
                              downstream_controller_port, 'root@system', 'changeme')
    print_border()
