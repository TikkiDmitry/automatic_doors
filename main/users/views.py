from rest_framework import generics
from rest_framework import permissions
from rest_framework.views import APIView
from .models import CustomUser, Schedule, EntryExit
from .serializers import CustomUserSerializer, ScheduleSerializer, EntryExitSerializer
from rest_framework.response import Response


# Вывод и обновление данных
class CustomUserDetail(generics.RetrieveUpdateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [permissions.IsAuthenticated]


class CurrentUserView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        serializer = CustomUserSerializer(user)
        data = serializer.data
        data['is_superuser'] = user.is_superuser
        return Response(data)


# Вывод данных
class ScheduleDetail(generics.ListAPIView):
    serializer_class = ScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user_id = self.kwargs['user_id']
        queryset = Schedule.objects.filter(id_user=user_id).order_by('start_datetime')

        # Получаем параметр room_id из запроса
        room_id = self.request.query_params.get('room')
        # Если room_id задан, фильтруем расписание по этому id помещения
        if room_id:
            queryset = queryset.filter(room__id=room_id)

        # Фильтрация по дню недели, если указан
        day_of_week = self.request.query_params.get('day_of_week')
        if day_of_week:
            queryset = queryset.filter(day_of_week__day_week=day_of_week)

        return queryset


# Отправка и получение данных
class EntryExitListCreate(generics.ListCreateAPIView):
    queryset = EntryExit.objects.all()
    serializer_class = EntryExitSerializer
    permission_classes = [permissions.IsAuthenticated]

