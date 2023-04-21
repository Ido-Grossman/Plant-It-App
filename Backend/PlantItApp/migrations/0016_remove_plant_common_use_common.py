# Generated by Django 4.1.7 on 2023-04-21 13:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0015_remove_plant_use'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='plant',
            name='common',
        ),
        migrations.CreateModel(
            name='use',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('use', models.CharField(max_length=50)),
                ('plant', models.ManyToManyField(to='PlantItApp.plant')),
            ],
        ),
        migrations.CreateModel(
            name='common',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('common', models.CharField(max_length=50)),
                ('plant', models.ManyToManyField(to='PlantItApp.plant')),
            ],
        ),
    ]
