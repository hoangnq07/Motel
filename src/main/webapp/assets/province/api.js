$(function () {
    apiProvince = (province) => {
        let district;

        province.forEach(element => {
            $('#province').append(`<option value="${element.code}">${element.name}</option>`);
        });

        // Chọn province nếu motel không null
        if (motelProvince) {
            $('#province').val(motelProvince);
            $('#province').trigger('change');
        }

        $('#province').change(function () {
            $('#district').html('<option value="-1">Chọn quận/huyện</option>');
            $('#town').html('<option value="-1">Chọn phường/xã</option>');
            let value = $(this).val();
            $.each(province, function(index, element) {
                if (element.code == value) {
                    district = element.districts;
                    $.each(element.districts, function(index, element1) {
                        $('#district').append(`<option value="${element1.code}">${element1.name}</option>`);
                    });

                    // Chọn district nếu motel không null
                    if (motelDistrict) {
                        $('#district').val(motelDistrict);
                        $('#district').trigger('change');
                    }
                }
            });
            updateHiddenInputs();
        });

        $('#district').change(function () {
            $('#town').html('<option value="-1">Chọn phường/xã</option>');
            let value = $(this).val();
            $.each(district, function(index, element) {
                if (element.code == value) {
                    element.wards.forEach(element1 => {
                        $('#town').append(`<option value="${element1.code}">${element1.name}</option>`);
                    });

                    // Chọn town nếu motel không null
                    if (motelTown) {
                        $('#town option').filter(function() {
                            return $(this).text() === motelTown;
                        }).prop('selected', true);
                    }
                }
            });
            updateHiddenInputs();
        });

        $('#town').change(updateHiddenInputs);

        // Trigger initial updates if motel data exists
        if (motelProvince) {
            $('#province').trigger('change');
        }
    }

    province = JSON.parse(data);
    apiProvince(province);
});

function updateHiddenInputs() {
    var provinceSelect = document.getElementById('province');
    var districtSelect = document.getElementById('district');
    var townSelect = document.getElementById('town');

    var selectedProvinceText = provinceSelect.selectedIndex > 0 ? provinceSelect.options[provinceSelect.selectedIndex].text : '';
    var selectedDistrictText = districtSelect.selectedIndex > 0 ? districtSelect.options[districtSelect.selectedIndex].text : '';
    var selectedTownText = townSelect.selectedIndex > 0 ? townSelect.options[townSelect.selectedIndex].text : '';

    document.getElementById('provinceText').value = selectedProvinceText;
    document.getElementById('districtText').value = selectedDistrictText;
    document.getElementById('townText').value = selectedTownText;

    console.log('Updated hidden inputs:', selectedProvinceText, selectedDistrictText, selectedTownText);
}