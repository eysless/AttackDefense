from caronteInteract import *
from flask import Flask, render_template, request, jsonify

password = 'e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'
caronteip = '127.0.0.1:1111'
caronte = Caronte(f"http://root:{password}@{caronteip}")


app = Flask(__name__)
global serverip
def handle_input(user_input):
    print(f"User typed: {user_input}")
    return f"Received: {user_input}"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process', methods=['POST'])
def process():
    data = request.get_json()
    user_input = data.get('text')
    result = handle_input(user_input)
    return jsonify({'result': result})

@app.route('/ipProcess', methods=['POST'])
def ipProcess():
    data = request.get_json()
    user_input = data.get('text')
    serverip = user_input
    result = caronte.setup(serverip,'root',password)
    return jsonify({'result': result})

@app.route('/launchSetup', methods=['POST'])
def launchSetup():
    data = request.get_json()
    user_input = data.get('text')
    result = handle_input(user_input)
    serverip = user_input
    return jsonify({'risposta': result})

if __name__ == '__main__':
    app.run(debug=True)

