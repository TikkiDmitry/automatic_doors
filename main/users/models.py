from django.db import models
from django.contrib.auth.models import AbstractUser
from rooms.models import Rooms


class JobTitle(models.Model):
    job_title = models.CharField('Должность', max_length=50)

    class Meta:
        verbose_name = 'Должность'
        verbose_name_plural = 'Должности'

    def __str__(self):
        return self.job_title


class CustomUser(AbstractUser):
    first_name = None
    last_name = None
    fio = models.CharField('ФИО', max_length=70)
    job_title = models.ForeignKey(JobTitle, on_delete=models.SET_NULL, null=True, verbose_name='Должность')
    passport_details = models.CharField('Паспортные данные', max_length=150)
    address = models.CharField('Адрес', max_length=100)
    phone_number = models.CharField('Телефон', max_length=20)
    biometrics = models.CharField('Биометрические данные', max_length=100)
    photo = models.ImageField('Фото', upload_to='user_photos/', null=True, blank=True)

    class Meta:
        verbose_name = 'Пользователь'
        verbose_name_plural = 'Пользователи'


class DayWeek(models.Model):
    day_week = models.CharField('День недели', max_length=15)

    class Meta:
        verbose_name = 'День недели'
        verbose_name_plural = 'Дни недели'

    def __str__(self):
        return self.day_week


class Schedule(models.Model):
    id_user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name='ID пользователя')
    day_of_week = models.ForeignKey(DayWeek, on_delete=models.CASCADE, verbose_name='День недели')
    room = models.ForeignKey(Rooms, on_delete=models.SET_NULL, null=True, verbose_name='Помещение')
    date = models.DateTimeField('Дата и время', auto_now_add=True)

    class Meta:
        verbose_name = 'Расписание'
        verbose_name_plural = 'Расписание'


class EntryExit(models.Model):
    id_user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name='ID пользователя')
    day_of_the_week = models.ForeignKey(DayWeek, on_delete=models.CASCADE, verbose_name='День недели')
    date = models.DateTimeField('Дата и время', auto_now_add=True)
    room = models.ForeignKey(Rooms, on_delete=models.SET_NULL, blank=True, null=True, verbose_name='Помещение')
    entry = models.BooleanField('Вход')
    exit = models.BooleanField('Выход')
    main_entry = models.BooleanField('Вход на предприятие')
    main_exit = models.BooleanField('Выход с предприятия')

    class Meta:
        verbose_name = 'Вход/выход'
        verbose_name_plural = 'Вход/выход'

    def __str__(self):
        return str(self.date)
