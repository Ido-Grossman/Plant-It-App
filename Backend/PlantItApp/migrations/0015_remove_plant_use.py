# Generated by Django 4.1.7 on 2023-04-21 13:55

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0014_plant_plant_photo'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='plant',
            name='use',
        ),
    ]