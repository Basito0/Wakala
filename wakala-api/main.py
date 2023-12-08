from flask import Flask, jsonify, request
from posts import posts
from users import users
app = Flask(__name__)


@app.route('/ping')
def ping():
    return jsonify({"message": "pong"})


@app.route('/posts')
def get_posts():
    return jsonify(posts)


@app.route("/posts/<string:username>")
def getPostsByUser(username):
    posts_found = []
    for post in posts:
        if post["username"] == username:
            posts_found.append(post)
    if len(posts_found) > 0:
        return posts_found
    return "No se encontraron posts"


@app.route('/posts', methods=["POST"])
def add_post():
    print(request.json)
    return "recibido"


@app.route('/userlist')
def get_users():
    return jsonify(users)

@app.route('/userlist', methods=["POST"])
def add_user():
    new_user = {"username": request.json["username"],
                "email": request.json["email"],
                "password": request.json["password"]}
    # si el username o el email estan en uso entonces no se agrega el usuario
    for existent_user in users:
        if new_user["username"] == existent_user["username"]:
            return "Ese nombre de usuario ya está en uso"
        if new_user["email"] == existent_user["email"]:
            return "Esa dirección de correo ya está en uso"
    users.append(new_user)
    return "recibido"



if __name__ == '__main__':
    app.run(debug=True, port=4000)