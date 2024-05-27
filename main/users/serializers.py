from rest_framework import serializers
from .models import JobTitle, CustomUser, Schedule, DayWeek, EntryExit
from rooms.serializers import RoomsSerializer


class JobTitleSerializer(serializers.ModelSerializer):
    class Meta:
        model = JobTitle
        fields = ['job_title']


class DayWeekSerializer(serializers.ModelSerializer):
    class Meta:
        model = DayWeek
        fields = ['day_week']


class CustomUserSerializer(serializers.ModelSerializer):
    job_title = JobTitleSerializer()

    class Meta:
        model = CustomUser
        fields = '__all__'


class ScheduleSerializer(serializers.ModelSerializer):
    id_user = CustomUserSerializer()
    day_of_week = DayWeekSerializer()
    room = RoomsSerializer()
    start_time = serializers.SerializerMethodField()
    end_time = serializers.SerializerMethodField()

    class Meta:
        model = Schedule
        fields = ['id_user', 'day_of_week', 'room', 'start_time', 'end_time']

    def get_start_time(self, obj):
        return obj.start_datetime.strftime('%H:%M')

    def get_end_time(self, obj):
        return obj.end_datetime.strftime('%H:%M')


class EntryExitSerializer(serializers.ModelSerializer):
    id_user = CustomUserSerializer()
    day_of_the_week = DayWeekSerializer()
    room = RoomsSerializer()

    class Meta:
        model = EntryExit
        fields = ['id_user', 'day_of_the_week', 'date', 'room', 'entry', 'exit', 'main_entry', 'main_exit']