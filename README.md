# Hướng dẫn

## Chuẩn bị:

## Đăng nhập hệ thống

Phiên bản này có hỗ trợ upload trực tiếp text lên server không cần thông qua html,
cho nên bạn cần phải đăng nhập trước khi thực hiện các thao tác tiếp theo.

Hướng dẫn đăng nhập

1. Mở command line đến thư mục chứa file `cvtxt.exe`.

2. Chạy câu lệnh

```
cvtxt.exe login
```

Chương trình sẽ yêu cầu bạn nhập email và mật khẩu.
Nếu đăng nhập thành công, thông tin đăng nhập của bạn (gồm tên đăng nhập và cookie)
sẽ được lưu vào 2 file là `cvuser.txt` chứa tên đăng nhập của bạn và `cookie.txt` chứa
thông tin đăng nhập nằm trong cùng thư mục với `cvtxt.exe`.

Lưu ý. File `cvuser.txt` có 2 tác dụng, một là để kiểm tra thông tin cookie có trùng khớp với thông tin người dùng, hai là để lưu thông tin người dùng vào mục lục chương tiết.

Nếu bạn không muốn upload nội dung chương tiết thông qua câu lệnh, mà muốn tự làm thủ công, hoặc gửi thông tin tới ban quản trị, có thể bỏ qua bước này.

Bạn cũng có thể tạo thủ công tệp `cvuser.txt` và điền tên sử dụng trên Chivi của bạn vào mà không cần đăng nhập. Thông tin người dùng trong thông tin chương tiết rất có tác dụng với ban quản trị :)

## Chuẩn bị dữ liệu

Nên xoá rác trước khi phân tách chương, ví dụ nội dung giản giới ở đầu tiên,
hoặc nguồn download text ở đầu/cuối văn bản.

## Chạy chương trình phân tách chương

2. Chạy `cvtxt.exe split [đường dẫn tới text truyện]`

Ví dụ tên text là `ten-truyen.txt`, nhập vào như sau:

```
cvtxt.exe split ten-truyen.txt
```

Kết quả sẽ được lưu vào trong thư mục `texts/ten-truyen`, gồm có:

- Các chương tiết đơn lẻ sẽ được lưu vào các thư mục con đánh số bắt đầu từ 0, mỗi
  thư mục con chứa nhiều nhất là 128 chương.

- Một chương tiết nếu nhiều hơn 4500 ký tự có thể được chia thành nhiều phần, mỗi phần
  có độ dài khoảng 2250 ký tự tới 4500 ký tự (thường thì là 3000 ký tự)

- Tên tệp của mỗi chương có dạng `[chương số * 10 (*)]-[phần số].txt`.
  Chương số bắt đầu từ 1, phần số bắt đầu từ 0.

- Các chương tiết trong cùng một thư mục sẽ được gộp lại vào một file zip trùng tên.
  Ví dụ thư mục `texts/ten-truyen/0` sẽ có file zip tương ứng là `text/ten-truyen/0.zip`

- Với mỗi thư mục con/file zip ví dụ `0.zip`, sẽ có một file text `0.tsv` chứa thông tin
  của các chương tiết theo nhiều dòng, mỗi dòng có định dạng:
  `[chương số] [chương số * 10 (*)] [tên chương] [tên tập truyện] [thời gian] [số chữ] [số phần] [tên người dùng]`

  (\*): Nguồn `users` trên chivi hỗ trợ lưu nhiều phiên bản text (tối đa là 10), việc nhân chương số
  với 10 là để dành khoảng trống cho các phiên bản sau.

**Lưu ý:**

- Kiểm tra xem kết quả có đúng không, đặc biệt là phần mã hoá ký tự (character encoding).
  Thường thì mã hoá ký tự của các file text tiếng Trung đều là GBK, nhưng có thể gặp các
  trường hợp cá biệt, ví dụ UTF-8, UTF-16

  Kiểm tra xem kết quả trong thư mục `texts/ten-truyen`, nếu thay vì là các ký tự tiếng Trung
  nó toàn là ký tự rác, thì bạn nên thêm thông tin của mã hoá ký tự vào trong câu lệnh.

  Ví dụ mã hoá là `UTF-8`, câu lệnh như sau

  ```
  cvtxt.exe split ten-truyen.txt -e UTF-8
  ```

  `utf-8`, `utf8`, `u8` đều nhận là UTF-8.

  Tương tự với UTF-16.
