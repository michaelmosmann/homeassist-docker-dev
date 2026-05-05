"""Sensor platform for My Integration."""
from __future__ import annotations

from homeassistant.components.sensor import SensorEntity, SensorStateClass
from homeassistant.config_entries import ConfigEntry
from homeassistant.core import HomeAssistant
from homeassistant.helpers.entity_platform import AddEntitiesCallback

from .const import DOMAIN


async def async_setup_entry(
    hass: HomeAssistant,
    entry: ConfigEntry,
    async_add_entities: AddEntitiesCallback,
) -> None:
    """Set up sensors from a config entry."""
    data = hass.data[DOMAIN][entry.entry_id]
    async_add_entities([MyIntegrationSensor(entry.entry_id, data)])


class MyIntegrationSensor(SensorEntity):
    """Representation of a sensor."""

    _attr_state_class = SensorStateClass.MEASUREMENT

    def __init__(self, entry_id: str, config: dict) -> None:
        self._entry_id = entry_id
        self._config = config
        self._attr_unique_id = f"{entry_id}_sensor"
        self._attr_name = config.get("name", "My Sensor")
        self._attr_native_value = 42

    async def async_update(self) -> None:
        """Fetch new state data for the sensor."""
        # Replace with your actual data fetching logic
        self._attr_native_value = 42
