from caronteInteract import *
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True)
