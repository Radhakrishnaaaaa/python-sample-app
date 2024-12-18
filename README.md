apt install python3
apt install python3-pip -y
mkdir /app
apt install python3.12-venv -y
python3 -m venv /app/venv
. /app/venv/bin/activate
/app/venv/bin/pip install -r requirements.txt
cd devops
python3 manage.py runserver 0.0.0.0:8000
