String dateToStringDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String dateToDetailDate(DateTime date) {
  return "${namaHari(date.weekday % 7)}, ${date.day.toString().padLeft(2, '0')} ${namaBulan(date.month)} ${date.year.toString().padLeft(4, '0')}";
}

String detailDateToStringDate(String detailDate) {
  List<String> parts = detailDate.split(', ');
  String datePart = parts[1];
  
  List<String> dateParts = datePart.split(' ');
  String day = dateParts[0];
  String monthName = dateParts[1];
  String year = dateParts[2];

  return "$year-${monthIndex(monthName).toString().padLeft(2, '0')}-${day.padLeft(2, '0')}";
}

String namaHari(int index) {
  switch (index) {
    case 0:
      return "Minggu";
    case 1:
      return "Senin";
    case 2:
      return "Selasa";
    case 3:
      return "Rabu";
    case 4:
      return "Kamis";
    case 5:
      return "Jumat";
    case 6:
      return "Sabtu";
  }
  return "";
}

String namaBulan(int index) {
  switch (index) {
    case 1:
      return "Januari";
    case 2:
      return "Februari";
    case 3:
      return "Maret";
    case 4:
      return "April";
    case 5:
      return "Mei";
    case 6:
      return "Juni";
    case 7:
      return "Juli";
    case 8:
      return "Agustus";
    case 9:
      return "September";
    case 10:
      return "Oktober";
    case 11:
      return "November";
    case 12:
      return "Desember";
  }
  return "";
}

int monthIndex(String monthName) {
  switch (monthName) {
    case "Januari":
      return 1;
    case "Februari":
      return 2;
    case "Maret":
      return 3;
    case "April":
      return 4;
    case "Mei":
      return 5;
    case "Juni":
      return 6;
    case "Juli":
      return 7;
    case "Agustus":
      return 8;
    case "September":
      return 9;
    case "Oktober":
      return 10;
    case "November":
      return 11;
    case "Desember":
      return 12;
  }
  return 0;
}

