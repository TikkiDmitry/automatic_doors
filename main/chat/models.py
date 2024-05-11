from django.db import models
from users.models import CustomUser


class ChatMessage(models.Model):
    sender = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name='Отправитель',
                               related_name='sent_messages')
    recipient = models.ForeignKey(CustomUser, on_delete=models.CASCADE, verbose_name='Получатель',
                                  related_name='received_messages')
    message = models.TextField('Сообщение')
    time = models.DateTimeField('Время', auto_now_add=True)

    class Meta:
        verbose_name = 'Сообщение чата'
        verbose_name_plural = 'Сообщения чата'

