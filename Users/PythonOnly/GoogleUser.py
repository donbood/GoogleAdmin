class GoogleUser():

    def __init__(self, user):
        self._email = user['primaryEmail']
        self._fullName = user['name']['fullName']
        self._firstName = user['name']['givenName']
        self._lastName = user['name']['familyName']
        self._OU = user['orgUnitPath']


    @property
    def email(self):
        return self._email

    @property
    def fullName(self):
        return self._fullName

    @property
    def firstName(self):
        return self._firstName

    @property
    def lastName(self):
        return self._lastName

    @property
    def OU(self):
        return self._OU



