from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, JobTitle, DayWeek, Schedule, EntryExit


class CustomUserAdmin(UserAdmin):
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal info',
         {'fields': ('fio', 'job_title', 'passport_details', 'address', 'phone_number', 'biometrics', 'photo')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )
    list_display = ('username', 'fio', 'job_title', 'phone_number', 'is_staff')


class ScheduleAdmin(admin.ModelAdmin):
    list_display = ('id_user', 'day_of_week', 'room', 'start_datetime', 'end_datetime')


class EntryExitAdmin(admin.ModelAdmin):
    list_display = ('id_user', 'day_of_the_week', 'room', 'entry', 'main_entry', 'date')


admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(JobTitle)
admin.site.register(DayWeek)
admin.site.register(Schedule, ScheduleAdmin)
admin.site.register(EntryExit, EntryExitAdmin)
