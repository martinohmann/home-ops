import os

AUTHENTICATION_SOURCES = ['oauth2', 'internal']
OAUTH2_AUTO_CREATE_USER = True
OAUTH2_CONFIG = [{
	'OAUTH2_NAME' : 'authentik',
	'OAUTH2_DISPLAY_NAME' : 'Authentik',
	'OAUTH2_CLIENT_ID' : os.environ['OAUTH2_CLIENT_ID'],
	'OAUTH2_CLIENT_SECRET' : os.environ['OAUTH2_CLIENT_SECRET'],
	'OAUTH2_TOKEN_URL' : 'https://identity.18b.haus/application/o/token/',
	'OAUTH2_AUTHORIZATION_URL' : 'https://identity.18b.haus/application/o/authorize/',
	'OAUTH2_API_BASE_URL' : 'https://identity.18b.haus/',
	'OAUTH2_USERINFO_ENDPOINT' : 'https://identity.18b.haus/application/o/userinfo/',
	'OAUTH2_SERVER_METADATA_URL' : 'https://identity.18b.haus/application/o/pgadmin/.well-known/openid-configuration',
	'OAUTH2_SCOPE' : 'openid email profile',
	'OAUTH2_ICON' : 'fa-fingerprint',
	'OAUTH2_BUTTON_COLOR' : '#0066CC'
}]
