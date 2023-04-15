# Generated by Django 4.1.7 on 2023-04-15 13:28

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0011_plant_user_plants'),
    ]

    operations = [
        migrations.RenameField(
            model_name='plant',
            old_name='Category',
            new_name='category',
        ),
        migrations.RenameField(
            model_name='plant',
            old_name='Climate',
            new_name='climate',
        ),
        migrations.RenameField(
            model_name='plant',
            old_name='Family',
            new_name='family',
        ),
        migrations.RenameField(
            model_name='plant',
            old_name='Idealight',
            new_name='idealight',
        ),
        migrations.AddField(
            model_name='plant',
            name='origin',
            field=models.CharField(default=None, max_length=30),
            preserve_default=False,
        ),
    ]