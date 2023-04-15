# Generated by Django 4.1.7 on 2023-04-15 13:22

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0009_customuser_profile_picture_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user_plants',
            name='plant',
        ),
        migrations.RemoveField(
            model_name='user_plants',
            name='user',
        ),
        migrations.AlterField(
            model_name='customuser',
            name='profile_picture',
            field=models.ImageField(default='profile_pictures/default-profile-picture.jpg', upload_to='profile_pictures/'),
        ),
        migrations.DeleteModel(
            name='Plant',
        ),
        migrations.DeleteModel(
            name='Plant_Genus',
        ),
        migrations.DeleteModel(
            name='User_Plants',
        ),
    ]