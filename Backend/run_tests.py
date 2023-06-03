import subprocess

test_commands = [
    "python3 manage.py test PlantItApp.controllers.Accounts.tests.test_forget_password",
    "python3 manage.py test PlantItApp.controllers.Accounts.tests.test_login",
    "python3 manage.py test PlantItApp.controllers.Accounts.tests.test_logout",
    "python3 manage.py test PlantItApp.controllers.Accounts.tests.test_register",
    "python3 manage.py test PlantItApp.controllers.Plants.tests.test_plants",
    "python3 manage.py test PlantItApp.controllers.Posts.tests.test_posts",
]

for command in test_commands:
    print("\033[92m" + "Running: " + command + "\033[0m")
    subprocess.run(command, shell=True)
