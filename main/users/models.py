from django.db import models
from django.contrib.auth.models import AbstractUser


class JobTitle(models.Model):
    job_title = models.CharField('Должность', max_length=50)

    class Meta:
        verbose_name = 'Должность'
        verbose_name_plural = 'Должности'


class CustomUser(AbstractUser):
    first_name = None
    last_name = None
    fio = models.CharField('ФИО', max_length=70, default='')
    job_title = models.ForeignKey(JobTitle, on_delete=models.SET_NULL, null=True, verbose_name='Должность')
    passport_details = models.CharField('Паспортные данные', max_length=150, default='')
    address = models.CharField('Адрес', max_length=100, default='')
    phone_number = models.CharField('Телефон', max_length=20, default='')
    biometrics = models.CharField('Биометрические данные', max_length=100, default='')
    photo = models.ImageField('Фото', upload_to='user_photos/', null=True, blank=True)

    class Meta:
        verbose_name = 'Пользователь'
        verbose_name_plural = 'Пользователи'
