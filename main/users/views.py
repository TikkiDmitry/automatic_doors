from rest_framework import generics
from rest_framework import permissions
from .models import CustomUser, Schedule, EntryExit
from .serializers import CustomUserSerializer, ScheduleSerializer, EntryExitSerializer


# Вывод и обновление данных
class CustomUserDetail(generics.RetrieveUpdateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [permissions.IsAuthenticated]


# Вывод данных
class ScheduleDetail(generics.RetrieveAPIView):
    queryset = Schedule.objects.all()
    serializer_class = ScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]


# Отправка и получение данных
class EntryExitListCreate(generics.ListCreateAPIView):
    queryset = EntryExit.objects.all()
    serializer_class = EntryExitSerializer
    permission_classes = [permissions.IsAuthenticated]

