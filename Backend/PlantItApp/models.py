from django.db import models
from django.contrib.auth.models import User, AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.conf import settings
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from django.contrib.auth.hashers import make_password, check_password


class Plant_Genus(models.Model):
    name = models.CharField(max_length=150)
    water_duration = models.IntegerField()
    water_consumption = models.CharField(default=None, max_length=300)
    minimum_celsius = models.IntegerField(default=0)
    maximum_celsius = models.IntegerField(default=20)
    sun_light = models.CharField(max_length=100, default=None)
    humidity = models.IntegerField(default=None)
    type = models.CharField(max_length=100, default=None)
    description = models.CharField(max_length=1000, default=None)


class Plant(models.Model):
    name = models.CharField(max_length=150)
    genus = models.ForeignKey(Plant_Genus, default=None, on_delete=models.CASCADE)
    users = models.ManyToManyField(settings.AUTH_USER_MODEL, through='User_Plants')


class User_Plants(models.Model):
    plant = models.ForeignKey(Plant, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    last_watering = models.DateField(6)
    is_healthy = models.SmallIntegerField(default=1)


class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, uid=None, **kwargs):
        if not email:
            raise ValueError('Email is required')

        email = self.normalize_email(email)
        user = self.model(email=email, **kwargs)
        if uid:
            user.uid = make_password(uid)
        user.password = make_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, uid=None, **kwargs):
        user = self.create_user(email, password=password, uid=uid, **kwargs)
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user

    def check_uid(self, email, uid):
        try:
            user = self.get(email=email)
        except self.model.DoesNotExist:
            return False
        return check_password(uid, user.uid)


class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    uid = models.CharField(max_length=100, unique=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    first_name = models.CharField(max_length=100, default=None, null=True)
    last_name = models.CharField(max_length=100, default=None, null=True)

    objects = CustomUserManager()

    USERNAME_FIELD = 'email'

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')

    def __str__(self):
        return self.email

    def check_password(self, raw_password):
        return check_password(raw_password, self.password)

    def check_uid(self, raw_uid):
        return check_password(raw_uid, self.uid)
