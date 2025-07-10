---
title: "Thiết Lập Nền Tảng"
date: 2025-07-10T18:00:00+07:00
weight: 10
chapter: true
pre: "<b>I. </b>"
---

# Giai Đoạn I: Thiết Lập Nền Tảng
## AWS Account, Bảo Mật, và Môi Trường Phát Triển

{{% notice info %}}
**Thời gian**: 60 phút | **Trọng tâm**: Thiết lập AWS Account, Cấu hình Bảo mật, Công cụ Phát triển
{{% /notice %}}

### 🎯 Tổng Quan Giai Đoạn

Trong giai đoạn nền tảng này, bạn sẽ thiết lập cơ sở hạ tầng thiết yếu cần thiết để triển khai ColorLab trên AWS. Điều này bao gồm tạo và bảo mật tài khoản AWS, thiết lập quản lý truy cập phù hợp, và chuẩn bị môi trường phát triển với tất cả các công cụ cần thiết.

### 📋 Những Gì Bạn Sẽ Hoàn Thành

Đến cuối giai đoạn này, bạn sẽ có:

- ✅ **AWS Account Bảo Mật**: Được tạo với MFA và cảnh báo billing phù hợp
- ✅ **Bảo Mật IAM**: Admin user, groups, và least-privilege policies được cấu hình
- ✅ **Môi Trường Phát Triển**: Tất cả công cụ cần thiết được cài đặt và cấu hình
- ✅ **AWS CLI**: Được cấu hình đúng cách với credentials và đã test truy cập
- ✅ **Cấu Trúc Dự Án**: Cấu trúc thư mục có tổ chức cho tài liệu workshop

### 🏗️ Thành Phần Giai Đoạn

Giai đoạn này bao gồm 4 modules thiết yếu:

| Module | Chủ Đề | Thời Gian | Mô Tả |
|--------|---------|-----------|-------|
| **1.1** | [Tạo AWS Account](1-1-aws-account/) | 20 phút | Tạo tài khoản AWS với cấu hình phù hợp |
| **1.2** | [Bảo Mật & Quản Lý Truy Cập](1-2-security-access/) | 25 phút | Thiết lập MFA, IAM users, groups, và policies |
| **1.3** | [Môi Trường Phát Triển](1-3-dev-environment/) | 15 phút | Cài đặt công cụ, thiết lập cấu trúc dự án |
| **1.4** | [Cấu Hình AWS CLI](1-4-aws-cli/) | 10 phút | Cấu hình CLI, test truy cập, xác minh thiết lập |

### 🔒 Phương Pháp Bảo Mật Trước Tiên

Giai đoạn này nhấn mạnh các best practices bảo mật từ đầu:

- **Bảo Vệ Root Account**: MFA được kích hoạt, sử dụng hạn chế
- **Least Privilege Access**: IAM roles và policies phù hợp
- **Quản Lý Credentials**: Thực hành lưu trữ và rotation bảo mật
- **Thiết Lập Monitoring**: Cảnh báo billing và access logging

### 💰 Cân Nhắc Chi Phí

Tất cả hoạt động trong giai đoạn này **hoàn toàn miễn phí**:
- Tạo tài khoản AWS: Miễn phí
- Cấu hình IAM: Miễn phí
- Cài đặt công cụ: Miễn phí (công cụ mã nguồn mở)
- Thiết lập CLI: Miễn phí

### 🛠️ Công Cụ Bạn Sẽ Cài Đặt

- **AWS CLI**: Giao diện dòng lệnh cho các dịch vụ AWS
- **Python 3.11**: Runtime cho Lambda functions
- **Git**: Version control cho code của bạn
- **Text Editor**: VS Code hoặc tương tự cho phát triển

### ⚠️ Yêu Cầu Tiên Quyết Quan Trọng

Trước khi bắt đầu giai đoạn này, đảm bảo bạn có:
- Địa chỉ email hợp lệ cho tài khoản AWS
- Thẻ tín dụng để xác minh tài khoản (sẽ không bị tính phí)
- Máy tính có kết nối internet
- Quyền quản trị để cài đặt phần mềm

### 🎯 Tiêu Chí Thành Công

Bạn sẽ biết giai đoạn này hoàn thành khi:
- [ ] Tài khoản AWS được tạo và xác minh
- [ ] MFA được kích hoạt trên root account
- [ ] Admin IAM user được tạo và cấu hình
- [ ] Tất cả công cụ phát triển được cài đặt
- [ ] AWS CLI được cấu hình và test
- [ ] Có thể chạy thành công: `aws sts get-caller-identity`

---

{{% notice tip %}}
**Sẵn sàng bắt đầu?** Khởi đầu với [Module 1.1 - Tạo AWS Account](1-1-aws-account/) để tạo tài khoản AWS với cấu hình bảo mật phù hợp.
{{% /notice %}}

### 🔄 Điều Hướng Giai Đoạn

**Giai Đoạn Tiếp Theo**: [Giai Đoạn II - Triển Khai Dịch Vụ Cốt Lõi](../2-core-services/) (Lambda Functions & Thuật toán)

---

**Nền tảng là tất cả - hãy xây dựng đúng cách từ đầu!** 🏗️
