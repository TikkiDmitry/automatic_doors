from django.db import models


class LevelAccess(models.Model):
    access_level = models.CharField('Уровень доступа', max_length=15)

    class Meta:
        verbose_name = 'Уровень доступа'
        verbose_name_plural = 'Уровни доступа'

    def __str__(self):
        return self.access_level


class Rooms(models.Model):
    number_room = models.IntegerField('Номер помещения')
    access_level = models.ForeignKey(LevelAccess, on_delete=models.SET_NULL, null=True, verbose_name='Уровень доступа')

    class Meta:
        verbose_name = 'Помещение'
        verbose_name_plural = 'Помещения'

    def __str__(self):
        return str(self.number_room)


class AccessToRooms(models.Model):
    id_user = models.ForeignKey('users.CustomUser', on_delete=models.CASCADE, verbose_name='ID пользователя')
    number_room = models.ForeignKey(Rooms, on_delete=models.CASCADE, verbose_name='Номер помещения')
    # Нужна маска ввода
    time = models.CharField('Время')
    cause = models.CharField('Причина', max_length=150)
    result = models.BooleanField('Результат')
    cause_acc_den = models.CharField('Причина доступа/отказа', max_length=200)
    admin_part = models.BooleanField('Решение админа')
    time_req = models.DateTimeField('Дата и время запроса')

    class Meta:
        verbose_name = 'Запрос на доступ к помещению'
        verbose_name_plural = 'Запросы на доступ к помещениям'
