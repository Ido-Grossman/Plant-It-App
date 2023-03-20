from django.db import models

# Create your models here.
from django.db import models
from django.contrib.auth.models import User


class Plant(models.Model):
    name = models.CharField(max_length=150)
    water_duration = models.IntegerField()
    is_healthy = models.SmallIntegerField()
    optimal_weather = models.CharField(max_length=150)
    water_amount = models.IntegerField(0)
    users = models.ManyToManyField(User, through='User_Plants')


class User_Plants(models.Model):
    plant_id = models.ForeignKey(Plant, on_delete=models.CASCADE)
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    last_watering = models.DateField(6)
