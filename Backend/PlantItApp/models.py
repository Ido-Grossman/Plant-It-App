from django.db import models
from django.contrib.auth.models import User


class Plant(models.Model):
    name = models.CharField(max_length=150)
    water_duration = models.IntegerField()
    water_consumption = models.CharField(default=None, max_length=300)
    is_healthy = models.SmallIntegerField(default=1)
    minimum_celsius = models.IntegerField(default=0)
    maximum_celsius = models.IntegerField(default=20)
    sun_light = models.CharField(max_length=100, default=None)
    humidity = models.IntegerField(default=None)
    type = models.CharField(max_length=100, default=None)
    description = models.CharField(max_length=1000, default=None)
    users = models.ManyToManyField(User, through='User_Plants')


class User_Plants(models.Model):
    plant_id = models.ForeignKey(Plant, on_delete=models.CASCADE)
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    last_watering = models.DateField(6)
