# Generated by Django 5.0.3 on 2024-03-18 00:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('rooms', '0002_alter_rooms_number_room'),
    ]

    operations = [
        migrations.AlterField(
            model_name='accesstorooms',
            name='time',
            field=models.DateTimeField(auto_now_add=True, verbose_name='Дата и время'),
        ),
    ]
