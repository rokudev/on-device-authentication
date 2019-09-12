from flask import Flask, request
app = Flask(__name__)

@app.route('/')
def init():
    return {"message" : "Sample publisher server with information to cross check when doing on authentication check"}

# here are some sample endpoints in the publisher side that the channel will access
@app.route('/test/entitlement/', endpoint='entitlement', methods=["POST", "GET"])
@app.route('/test/tokenKey/', endpoint='tokenKey', methods=["POST", "GET"])
@app.route('/test/refreshToken/', endpoint='refreshToken', methods=["POST", "GET"])
def route():
    if request.endpoint == 'entitlement':
        # device has valid entitlement on publisher side
        msg = 'true'
    elif request.endpoint == 'tokenKey':
        # device has valid access token on publisher side
        msg = 'TOK8ZQEDDR8AWVJF8AH'
    elif request.endpoint == 'refreshToken':
        # device has vlaid refresh token on publisher side
        msg = 'REFMSEFAJ7A54SE3LBE'
    else:
        msg = 'route() called unexpectedly'

    return { request.endpoint : msg}

@app.route('/test/checkEmail/<email>')
def isLinkedEmail(email):
    # the logic for email validation should be done here
    # check if the email address linked to active sub is in the publisher system
    return 'false'
