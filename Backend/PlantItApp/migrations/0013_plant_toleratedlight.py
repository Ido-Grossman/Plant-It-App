# Generated by Django 4.1.7 on 2023-04-15 13:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('PlantItApp', '0012_rename_category_plant_category_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='plant',
            name='toleratedlight',
            field=models.CharField(default=None, max_length=150),
            preserve_default=False,
        ),
    ]