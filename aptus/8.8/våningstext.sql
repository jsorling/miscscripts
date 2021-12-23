update Object set FloorText = cast(substring(ApartmentNo, 1, 2) as int) - 10
where isnumeric(substring(ApartmentNo, 1, 2)) = 1