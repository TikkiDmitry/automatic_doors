from django.contrib import admin
from .models import LevelAccess, Rooms, AccessToRooms


class RoomsAdmin(admin.ModelAdmin):
    list_display = ('number_room', 'access_level')


class AccessToRoomsAdmin(admin.ModelAdmin):
    list_display = ('id_user', 'number_room', 'cause', 'time', 'result', 'cause_acc_den', 'time_req')


admin.site.register(LevelAccess)
admin.site.register(Rooms, RoomsAdmin)
admin.site.register(AccessToRooms, AccessToRoomsAdmin)
