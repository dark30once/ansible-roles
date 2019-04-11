import logging, sys, os
sys.path.insert(0,'.')
print(os.getcwd())
log = logging.getLogger(__name__)
from nightowl.app import app, db
from flask_migrate import stamp
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
ctx = app.app_context()
ctx.push()

try:
    curver = db.engine.execute("select version_num FROM alembic_version").fetchone()
except:
    curver = None
basever = '98cbec7f8cc9'

if curver is None:
    print("Flask migrate was never initialized. Setting version to {}".format(basever))
    stamp(revision=basever)
else:
    print("Current db version is {}".format(curver[0]))
