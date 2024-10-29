import pandas as pd
import qrcode
import matplotlib.pyplot as plt
import os
import time

# Cargar el archivo CSV
df_productos = pd.read_csv('InventarioPruebas.csv', encoding="utf-8", sep=";")

def actualizar_producto():
    tipo = input("Indique el tipo del producto: ")
    colegio = input("Indique el colegio al que pertenece el producto: ")
    talla = input("Indique la talla del producto: ")

    # Verificar si el producto existe
    producto_idx = df_productos[
        (df_productos['Tipo_producto'] == tipo) &
        (df_productos['Colegio_producto'] == colegio) &
        (df_productos['Talla_producto'] == talla)
    ].index

    if not producto_idx.empty:
        print("¿Qué te gustaría actualizar?")
        print("1. Aumentar las Unidades de un producto")
        print("2. Disminuir las unidades de un producto")
        opcion = int(input("Seleccione una opción (1, 2): "))
        if opcion == 1:
            adi_sus = int(input("Introduzca la cantidad de prendas a agregar: "))
        elif opcion == 2:
            adi_sus = int(input("Introduza la cantidad en que desea disminuir este producto: "))
            if adi_sus > df_productos.at[producto_idx[0], 'Cantidad_producto']:
                print("ERROR. SE DESEAN ELIMINAR MÁS INSTANCIAS DE LAS QUE HAY DISPONIBLES.")
                return
            adi_sus *= -1
            
        else:
            return
        df_productos.at[producto_idx[0], 'Cantidad_producto'] += adi_sus

             # Guardar los cambios en el archivo CSV
        df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)
        print("Cambios guardados en el archivo CSV.")
        
    else:
        print("El producto no existe en el inventario.")

    print(df_productos.head())

# ESTO NO ES UNA DEMOSTRACION ajajblabla


def eliminar_producto():
    tipo = input("Indique el tipo del producto: ")
    colegio = input("Indique el colegio al que pertenece el producto: ")
    talla = input("Indique la talla del producto: ")

    global df_productos
    df_productos = df_productos[
        ~((df_productos['Tipo_producto'] == tipo) & 
          (df_productos['Colegio_producto'] == colegio) & 
          (df_productos['Talla_producto'] == talla))
    ]

    print(f"Producto del tipo '{tipo}', colegio '{colegio}' y talla '{talla}' eliminado.")

    # Guardar los cambios en el archivo CSV
    df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)
    print("Cambios guardados en el archivo CSV.")

    print(df_productos.head())

    print(f"Producto del tipo '{tipo}', colegio '{colegio}' y talla '{talla}' eliminado.")

    print(df_productos.head())


def Agregar_producto():
    # Solicitar los datos del nuevo producto al usuario
    nuevo_producto = {
        "Tipo_producto": input("Introduce el tipo de producto: "),
        "Colegio_producto": input("Introduce el colegio al que pertenece: "),
        "Talla_producto": input("Introduce la talla del producto: "),
        "Cantidad_producto": input("Introduce la cantidad de productos: ")
    }

    # Convertir los datos en un DataFrame y añadir a los datos existentes
    nuevo_producto_df = pd.DataFrame([nuevo_producto])
    global df_productos
    df_productos = pd.concat([df_productos, nuevo_producto_df], ignore_index=True)

    # Generar el código QR con los datos del producto (sin la cantidad)
    data_qr = f"{nuevo_producto['Tipo_producto']}\n{nuevo_producto['Colegio_producto']}\n{nuevo_producto['Talla_producto']}"
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data_qr)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")

    ruta_carpeta_qr = "QRs productos"
    os.makedirs(ruta_carpeta_qr, exist_ok=True)
    id_unico = int(time.time())

    # Guardar el código QR como una imagen
    img.save(os.path.join(ruta_carpeta_qr, f"qr_producto_{id_unico}.png"))
    print("Código QR generado y guardado")

    # Guardar los datos actualizados en el archivo CSV
    df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)

    print("Producto añadido exitosamente.")
    print(df_productos.head())


def menu():
    opcion = 0
    while(opcion != 4):
        print("OPCIONES")
        print("1. Agregar Producto")
        print("2. Eliminar Producto")
        print("3. Modificar Producto")
        print("4. salir")
        opcion = int(input("Seleccione una opción:  "))
    
    
        if opcion == 3:
            actualizar_producto()
        elif opcion == 2:
            eliminar_producto()
        elif opcion == 1:
            Agregar_producto()

menu()
