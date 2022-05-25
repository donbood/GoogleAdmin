from __future__ import print_function

import os.path
import json

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

SCOPES = ['https://www.googleapis.com/auth/admin.directory.user']


def get_users():
    creds = None

    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)

        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    service = build('admin', 'directory_v1', credentials=creds)

    request = service.users().list(customer='my_customer', orderBy='email')
    response = request.execute()
    users = response.get('users', [])

    while request:
        request = service.users().list_next(previous_request=request, previous_response=response)
        if request:
            response = request.execute()
            users.extend(response.get('users', []))
    if not users:
        print('No users in the domain.')
    else:
        return(users)


if __name__ == '__main__':
    get_users()
