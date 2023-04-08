from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model

CustomUser = get_user_model()


class CustomAuthBackend(ModelBackend):
    def authenticate(self, request, email=None, password=None, uid=None, **kwargs):
        try:
            user = CustomUser.objects.get(email=email)
            if password is not None and user.check_password(password):
                return user
            if uid is not None and user.check_uid(uid):
                return user
        except CustomUser.DoesNotExist:
            return None
