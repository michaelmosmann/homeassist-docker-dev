"""Tests for the sensor platform."""
import pytest
from homeassistant.core import HomeAssistant
from pytest_homeassistant_custom_component.common import MockConfigEntry

from custom_components.my_integration.const import DOMAIN


@pytest.fixture
async def config_entry(hass: HomeAssistant) -> MockConfigEntry:
    """Create and load a mock config entry."""
    entry = MockConfigEntry(
        domain=DOMAIN,
        data={"name": "Test Sensor"},
        entry_id="test_entry_id",
    )
    entry.add_to_hass(hass)
    return entry


async def test_sensor_setup(hass: HomeAssistant, config_entry: MockConfigEntry) -> None:
    """Test that the sensor entity is created and has the expected state."""
    assert await hass.config_entries.async_setup(config_entry.entry_id)
    await hass.async_block_till_done()

    state = hass.states.get("sensor.test_sensor")
    assert state is not None
    assert state.state == "42"


async def test_sensor_unload(hass: HomeAssistant, config_entry: MockConfigEntry) -> None:
    """Test that the integration can be cleanly unloaded."""
    assert await hass.config_entries.async_setup(config_entry.entry_id)
    await hass.async_block_till_done()

    assert await hass.config_entries.async_unload(config_entry.entry_id)
    await hass.async_block_till_done()

    assert config_entry.entry_id not in hass.data.get(DOMAIN, {})
