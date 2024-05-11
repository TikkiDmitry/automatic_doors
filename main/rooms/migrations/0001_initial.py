# Generated by Django 5.0.3 on 2024-03-17 21:57

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='LevelAccess',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('access_level', models.CharField(max_length=15, verbose_name='Уровень доступа')),
            ],
            options={
                'verbose_name': 'Уровень доступа',
                'verbose_name_plural': 'Уровни доступа',
            },
        ),
        migrations.CreateModel(
            name='Rooms',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('number_room', models.IntegerField(max_length=10, verbose_name='Номер помещения')),
                ('access_level', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='rooms.levelaccess', verbose_name='Уровень доступа')),
            ],
            options={
                'verbose_name': 'Помещение',
                'verbose_name_plural': 'Помещения',
            },
        ),
        migrations.CreateModel(
            name='AccessToRooms',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('cause', models.CharField(max_length=150, verbose_name='Причина')),
                ('time', models.DateTimeField(auto_now_add=True, verbose_name='Время')),
                ('result', models.BooleanField(verbose_name='Результат')),
                ('cause_acc_den', models.CharField(max_length=200, verbose_name='Причина доступа/отказа')),
                ('id_user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='ID пользователя')),
                ('number_room', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='rooms.rooms', verbose_name='Номер помещения')),
            ],
            options={
                'verbose_name': 'Запрос на доступ к помещению',
                'verbose_name_plural': 'Запросы на доступ к помещениям',
            },
        ),
    ]