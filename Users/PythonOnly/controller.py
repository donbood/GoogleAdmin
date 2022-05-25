from quickstart import get_users
from GoogleUser import GoogleUser
from pprint import pprint
import csv
import sys


def parse_google_users(users):
    if not users:
        print("No users provided!")
    else:
        output_list = []

        for user in users:
            google_user = GoogleUser(user)
            output_list.append(google_user)

        return output_list


def format_google_users(list):
    if not list:
        print("No list provided!")
    else:
        output_list = []

        for item in list:
            user_dict = {
                "email": item.email,
                "fullName": item.fullName,
                "firstName": item.firstName,
                "lastName": item.lastName,
                "OU": item.OU
            }
            output_list.append(user_dict)

        return output_list


def get_ou_members(list, ou):
    if not list:
        print("No list provided!")
    else:

        output_list = []
        for item in list:
            if (item["OU"] == ou):
                output_list.append(item)

        return output_list


def output_csv(list, filename):
    if not list:
        print("No list provided!")
    else:

        with open(filename, 'w', encoding='utf8', newline='') as output_file:
            fc = csv.DictWriter(output_file, fieldnames=list[0].keys())
            fc.writeheader()
            fc.writerows(list)


def ou_to_csv(ou, output_file):
    filename = "%s.csv" % output_file

    output_csv(
        get_ou_members(
            format_google_users(
                parse_google_users(
                    get_users()
                )
            ), ou
        ),
        filename
    )


def main(ou,filename):
    ou_to_csv(ou,filename)


if __name__ == '__main__':
    main(sys.argv[1],sys.argv[2])
