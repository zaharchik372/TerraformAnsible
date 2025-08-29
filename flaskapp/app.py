from flask import Flask, render_template, request, jsonify
import os


app = Flask(__name__)




def _meta():
    return {
    "message": os.getenv("APP_MESSAGE", "Hello CI/CD 👋"),
    "commit": os.getenv("COMMIT_SHA", "dev"),
    "env": os.getenv("APP_ENV", "local"),
    }




@app.get("/")
def home():
    wants_json = request.args.get("json") == "1" or "application/json" in request.headers.get("Accept", "")
    if wants_json:
        return jsonify(_meta())
    return render_template("index.html", meta=_meta())




@app.get("/projects")
def projects():
    return render_template("projects.html")




@app.get("/projects/ansible")
def projects_ansible():
    return render_template("ansible.html")




@app.get("/projects/terraform")
def projects_terraform():
    return render_template("terraform.html")




@app.get("/api/info")
def api_info():
    return jsonify(_meta())




@app.get("/healthz")
def healthz():
    return {"status": "ok"}, 200




if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)