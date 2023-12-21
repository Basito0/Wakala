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



@app.route('/posts', methods=["POST"])
def add_post():
    # username queda como anonymous si no se provee
    username = request.json.get("username", "anonymous")
    new_post = {"sector": request.json["sector"],
                "fecha": request.json["fecha"],
                "descripcion": request.json["descripcion"],
                "username": username,
                "comentarios": [],
                "sigue_ahi_count": 0,
                "ya_no_esta_count": 0,
                "sigue_ahi_users": [],
                "ya_no_esta_users": [],
                    "id": len(posts)
                }
    posts.append(new_post)
    return "recibido"


@app.route('/posts/<int:post_id>/images', methods=["POST"])
def add_images(post_id):
    request_data = request.get_json()
    base64image1 = request_data['base64image1']
    base64image2 = request_data['base64image2']
    new_image = {"post_id": post_id, "base64image1": base64image1, "base64image2": base64image2}
    post_images.append(new_image)
    return "recibido"


@app.route('/posts/<int:post_id>/images', methods=["GET"])
def get_images(post_id):
    for image in post_images:
        if image["post_id"] == post_id:
            return jsonify(image)
    return "Imagenes no encontradas"


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
                # edita contador de sigue_ahi
                if request.json["username"] in post["sigue_ahi_users"]:
                    post["sigue_ahi_count"] -= request.json["sigue_ahi"]
                    post["sigue_ahi_users"].remove(request.json["username"])
                else:
                    post["sigue_ahi_count"] += request.json["sigue_ahi"]
                    post["sigue_ahi_users"].append(request.json["username"])

                # edita contador de ya_no_esta
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
