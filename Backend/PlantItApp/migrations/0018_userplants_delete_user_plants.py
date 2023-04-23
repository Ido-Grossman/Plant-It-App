# Generated by Django 4.1.7 on 2023-04-23 07:49

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0017_alter_common_plant_alter_use_plant'),
    ]

    operations = [
        migrations.CreateModel(
            name='UserPlants',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('last_watering', models.DateField(verbose_name=6)),
                ('is_healthy', models.SmallIntegerField(default=1)),
                ('nickname', models.CharField(default=None, max_length=100, null=True)),
                ('plant', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_plants', to='PlantItApp.plant')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='user_plants', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.DeleteModel(
            name='User_Plants',
        ),
    ]
