from flask import Flask, jsonify, request
from posts import posts
from users import users
from post_images import post_images

app = Flask(__name__)


@app.route('/ping', methods=["GET"])
def ping():
    return jsonify({"message": "pong"})


@app.route('/posts/<int:post_id>', methods=["GET"])
def get_post(post_id):
    for post in posts:
        if post['id'] == post_id:
            return jsonify(post)
    return "no se encontro post"


@app.route('/posts')
def get_posts():
    return jsonify(posts)


@app.route('/posts', methods=['POST'])
# devuelve todos los posts que pertenecen a un usuario dado
# usado para testeo
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
    # username defaults to anonymous if there is no username given
    username = request.json.get("username", "anonymous")
    new_post = {"sector": request.json["sector"],
                "descripcion": request.json["descripcion"],
                "username": username,
                "comentarios": [],
                "sigue_ahi_count": 0,
                "ya_no_esta_count": 0,
                "id": len(posts)
                }
    posts.append(new_post)
    return "recibido"


@app.route('/userlist/<int:post_id>/images', methods=["POST"])
def add_images(post_id):
    request_data = request.get_json()
    base64image1 = request_data['image1']
    base64image2 = request_data['image2']
    new_image = {"post_id": post_id, "base64image1": base64image1, "base64image2": base64image2}
    post_images.append(new_image)
    return "recibido"


@app.route('/userlist/<int:post_id>/images', methods=["GET"])
def get_images(post_id):
    for image in post_images:
        if image["post_id"] == post_id:
            return image
    return "no se encontro imagen"


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


# sirve para añadir comentarios o editar los contadores (por ej: sigue ahi) de un post
@app.route('/posts/<int:post_id>', methods=["PUT"])
def edit_post(post_id):
    if "comentario" in request.json:
        new_comment = {
            "comentario": request.json["comentario"],
            "username": request.json["username"]
        }
        for post in posts:
            if post["id"] == post_id:
                post["comentarios"].append(new_comment)
                return "recibido"
        return "Post no encontrado"

    if "sigue_ahi" in request.json:
        for post in posts:
            if post["id"] == post_id:
                if request.json["username"] in post["sigue_ahi_users"]:
                    post["sigue_ahi_count"] -= request.json["sigue_ahi"]
                    post["sigue_ahi_users"].remove(request.json["username"])
                else:
                    post["sigue_ahi_count"] += request.json["sigue_ahi"]
                    post["sigue_ahi_users"].append(request.json["username"])

                if request.json["username"] in post["ya_no_esta_users"]:
                    post["ya_no_esta_count"] -= request.json["ya_no_esta"]
                    post["ya_no_esta_users"].remove(request.json["username"])
                else:
                    post["ya_no_esta_count"] += request.json["ya_no_esta"]
                    post["ya_no_esta_users"].append(request.json["username"])
                return "recibido"
        return "post no encontrado"


@app.route('/userlist')
def get_users():
    return jsonify(users)


if __name__ == '__main__':
    app.run(debug=True, port=4000)
