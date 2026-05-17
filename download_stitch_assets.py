import os
import json
import subprocess

screens = [
    {"id": "c658a311f23444ed8845da6bac87d00a", "title": "You Won! - World of Discovery"},
    {"id": "fc584e7ce9cb480cb127d5eec3d2a328", "title": "Settings - World of Discovery"},
    {"id": "c3fde2cb4dfc46b39445d9186ebfd9e6", "title": "World of Similar Letters"},
    {"id": "a0c0b84efb2f4520bf3fd478bf67ecc2", "title": "World of Substitution"},
    {"id": "82337658c6bb4c99a0e1edd1fa0b7bc7", "title": "World of Addition"},
    {"id": "8f5295650798403b8e6b35554497631b", "title": "My Achievements"},
    {"id": "95b38d8335bf48c7957971e41c07837f", "title": "World of Distinction"},
    {"id": "c8fdb9566afd4eb4a584e33c4560bd05", "title": "Adventure Shop"},
    {"id": "b15809604ee34025b06aaa111c1a1c46", "title": "Home - World of Discovery"},
    {"id": "ab76407c75764989b7cb2ff5331d0427", "title": "World of Deletion"},
    {"id": "bed245fd22e343958c01770c142773d0", "title": "Game Hub - World of Discovery"}
]

# This data was extracted from the list_screens output
all_screen_data = {
    "c8fdb9566afd4eb4a584e33c4560bd05": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ugsM3OmnCcVl99AlnwBp_YMXRiw1mM_p1oDi7pJqyCIuj2blf736llyPmlkA35MJ_wu3ldDe1gkEU_a3XL9VACYx701b8ScBnHvb9VYs3KTnaFKKSDUayxtmERkjJBfar3OFypGZiRGV6__pb2heTzzGoWO6kL80-uNido0pcRW7o5qJ1vdZjs3L6VUk_QD3P2QBrDNqZPZc0WXB5lKbxCrfRIa66m_E24tzIwtmTK4vXsEKkZ23Z0XiS0",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzQ3N2U3NzMzOThlODRiZGNhM2UxNmRmYmIwMWQxYzlkEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "c658a311f23444ed8845da6bac87d00a": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0uhbfGwxi6nBPpVz8tEyreX8a4S5h0oxYqp__y58hdAgg12eSgQBZ50XbBOQNpBf4LTMJYZPTtpkK7bnKTUpStaWp2Cd2wKb-sVR_DJKY_4DwAIOf9-WH3ZnxH0hK1ClDRDqGMcsEi9c6rnOH4-EmxLMIWQe0_7xPo_abiE-RrxtJKnyrDX0m6ryRJa2luCEk2TU32_5gHAUvqOVtuH-7wcrqAto2hffIdXo61PwUfL6agfkg6dErgMrlsc",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzVkNWI1MDRlZTJmMTRiYzQ5NzFjYzdmNTkxNTIwYTlkEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "c3fde2cb4dfc46b39445d9186ebfd9e6": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0uhWqeqrY3_kgkxs1CE21b0p3wfnWsovR437YtsKRTKXmlr0EOkgMiQAyAVKDYhyzH6ccadDaMth8Wz6g-xCLqr3ORp6NCoxy6gI8OJeLyXvs3PkV3xK-Y3M4tBJQtIUhncAZNyVCQ8XPpg6XdZ9kf8YG6Bw1Oz5RWIlaB4qmAVOsii3yhGHlAhlmb6e5V2XKYXT3GMDy0qSKJYVmK041_l9S2pNefw0XEtue59uSpj2Ai5qO9e2s_aEzJM",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzhiYjczZjc0ZjJlMjRmZmRiNmExMDkyY2Q1MDJhZDFkEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "ab76407c75764989b7cb2ff5331d0427": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ujvDTvmnb9Cz8pT6P3EeEAJvGF-ncF0xOQrtdfItSOwPzrRR08QGRS9ezENTYJys5_Lg-wq1StwESbei5dnfMggjQ4WqQAQOcuxEL2WUG4eWblBUhJDstaBIQWO7Gl9b76mXOdPMkpMI8XW2hmpDoPOUeOr7MYUWmaQJFFH9sSTHSN-_tkSTdjpnDskqlDvNqAwc9eUP-7RUeDryvlX9CHlC7a_ByezeJj9UTvn89xCvNfAODLk3fzMyDI",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sX2NhNGQ1MTQxNjc4NzRmYmZiZWNmMjMyMWMyYTJhYmE3EgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "fc584e7ce9cb480cb127d5eec3d2a328": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0uhyKzdTTBpEMl4CzIIg0wB6aliyZitw4o-Kyu0-Y1aeC1cgnBzA_mDCuOol9-FF80LJT6aOppyF-JSY0ykwVY6uqv4HVoSfbwwuzOTXJFcuFUJj2yn_iTUC5EjXm9_gmEQIMukTKomIdNJp8X8h-TVOa5kBeuJ9VIp-XrQJCzi1tVzhU73aAr8qJ8RGYEEo4L0ubMd2aQhfXwJLvyjtONzojl77ET1Miz896WFXO5lwlW0uneJaSyMicNs",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzA4YWI2OWQ5MmUzYjRlNmM5NDFmOTkxM2Q0YWVhMmQyEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "95b38d8335bf48c7957971e41c07837f": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ugr06y-syvaHBAOnSC9qDlIF63B0sz9rRyLrPNr8EqeQyKkMF9KTG7oIGCvI7YlmbQUBM-jIZsKEaBNYEoW-XY5xMqcWLqFU4cKnp1f3tNqqOffb6GHO52hAEsO3o3nXCKjFEW544lgj1qaPc2Xv77vLsBQ34uaZzL_yGe2oeYKCVbyC1dMxa9x8xWM1kAJzi16exUY4jHYua8EgFCXBALnEtimxtZbtAZkR8J68CHMvb7BlN5lzonfPBI",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzQ4ZGY2MzMyM2FhNzQ0MDE5NTk1ZGNmZjQxZjRjODk2EgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "82337658c6bb4c99a0e1edd1fa0b7bc7": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0uj6NewhJaEEv0TeCJo9n1pKB35Wgj38sLnk3oC2jYFnjWUrK5T0DXMjk0O1Jv3ZAak73w20Oer_8dx65bkMuJzRmzCuHgbAk3Xoma_DeiPSGTG5QSFuS4N5fhpOZIrP1AJEB4wRbhPrdBHW8kYDFeFzb-qwyoCymxxHYs2U__bjHUeoNQp8wekQH43WUCoGAO6M49RT6jO_f_QlHatwJRaZL-TP4cO1JDHRb4vrrIjFIqdSJfQ9MJIGPg",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzM5Yzk3MjVjZjgxZDQyZjI4OWIyNTRjYWI0ZTJkZWY4EgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "bed245fd22e343958c01770c142773d0": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ujWszGvDa_TY88OpezceQTJCTJ9vM7nSwUyB8Gx4Fi0Ymfi5FvHJn4VAnd0JcF4sgD8ELVwZZYCS3JUeYWDKOcwoc8IZl-dpkFiCt7Q9z3GUF_v1j3nrRw4o5GNkHaLq4fFVFSwco1lfXVzmd3iDsVxXGTvYuhhqcf21daC1fZwNtm4RGzetgxjUo_Tcrxp57HoNQMU5iUYMXUmquDyo1hrrbMXuS7wUFSnalqhI5PHbTHLtvY8RzIW9IQ",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzNjODY0MGNhY2VjMzQ0ZTBiMjIyOTgxN2JiYjNlYzFlEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "b15809604ee34025b06aaa111c1a1c46": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ugynbdQe6OtqPvzKp_TTFgpCHjeHwCQB4qIX2_k6DIKb00qC0Wal5BRXyyX5Ul9NNlGpixtSDMVE1z71Vs4-nKGGe43Hn0mIvFHsJ1oPT72tSdrW4Z8A0I5eD7NGnbete-nJHkq_ZOBWynIukPgXPvIU0Pfg5ZPg9l6Ll9xkvuQf48pQPUF3dm9J7Gqn-SzokNbWiPcTktV9X977E8_l01_MB_Blw_5vEbmYvJTtQBZQBDUUqCwtYSBz00",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzkxNGQzZGM3ZmZlYTQ0Zjk4NGEyMjY4NjdkNjVhN2QzEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "8f5295650798403b8e6b35554497631b": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0ugO6rsTVIozH35zfyvvtRwefpo9SYtubr8hLQiLbbPuKWRNlXkpe7u8ZXrAFFInTn1XDItmOip8BmjjyKpA05vs2XRXG33jzbrshBi2YqlQ8itEcR45OsRShqjx7AtxiZye6PZDC_ZdSZkTqtNPiDmYjcXK_UmjvkfjnpEItjBrxYjzrVG-JhDGOHSQRwyLg5TzVUCZ8t3O7ttBw8Ciq1ZxQBhchuvrZaIWEBM1V6e3tLcuXunpyh7I0A",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzA0ZWMxODA5ZDEyZjRhMmU5NTNhZjA4MTkzOWVjZTQzEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    },
    "a0c0b84efb2f4520bf3fd478bf67ecc2": {
        "image": "https://lh3.googleusercontent.com/aida/ADBb0uiViEvDGbI8waE7bVuJb1ABQsQB2UPFoHgZYBSyJqrsvPnSHpzPHEnhQ5A4KtC_S94tbJvcPkxTu-obS1DiRLkby9hkCtSHMwZcPHzp1bRF-k4O2yF0Kl2q5BjyGixOaTPZ_DSgAuLYFn8tvz_P1YQa_33DNwVzSsYMzMoukYZXkCQkWbnzQy-ged6gBX2PSNVS_Eqp5dzKpHzqrXwGYIThyu-_p-5Tyy_1j6bJOIdYF2NYnjqFjPOAFg",
        "code": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sX2FjMTZjMzdiZDRjNzQ4NGE4YzNmZDBmNGM4Yzg5YTFjEgsSBxCWiKvEvxkYAZIBIwoKcHJvamVjdF9pZBIVQhM3MjU0MTI2NzE0MTA5OTU0NjI1&filename=&opi=89354086"
    }
}

os.makedirs("stitch_assets", exist_ok=True)

for screen in screens:
    s_id = screen["id"]
    title = screen["title"].replace(" ", "_").replace("!", "").replace("-", "_")
    data = all_screen_data.get(s_id)
    if data:
        img_url = data["image"]
        code_url = data["code"]
        
        img_path = os.path.join("stitch_assets", f"{title}.png")
        code_path = os.path.join("stitch_assets", f"{title}.html")
        
        print(f"Downloading {title}...")
        subprocess.run(["curl", "-L", img_url, "-o", img_path])
        subprocess.run(["curl", "-L", code_url, "-o", code_path])

print("Done!")
