from __future__ import print_function

import os.path
import json

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

SCOPES = ['https://www.googleapis.com/auth/admin.reports.audit.readonly']


def main():
    """Shows basic usage of the Admin SDK Reports API.
    """
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

    service = build('admin', 'reports_v1', credentials=creds)

    
    results = service.activities().list(userKey='all', applicationName='a').execute()
    activities = results.get('items', [])

    if not activities:
        print('No logs found.')
    else:
        jsonString = json.dumps(activities)
        print(jsonString)

if __name__ == '__main__':
    main()
