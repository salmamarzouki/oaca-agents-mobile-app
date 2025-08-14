from django.contrib import admin
from .models import Agent


@admin.register(Agent)
class AgentAdmin(admin.ModelAdmin):
    list_display = ['matricule', 'get_full_name', 'affectation', 'status', 'source_file', 'created_at']
    list_filter = ['affectation', 'status', 'source_file']
    search_fields = ['matricule', 'nom', 'prenom', 'nom_complet']
    readonly_fields = ['created_at', 'updated_at']

    def get_full_name(self, obj):
        return obj.get_full_name()
    get_full_name.short_description = 'Full Name'
