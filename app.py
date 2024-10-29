import pandas as pd
from datetime import datetime

# Cargar el archivo CSV
df_productos = pd.read_csv('InventarioPruebas.csv', encoding="utf-8", sep=";")

# Cargar el historial existente (si ya existe)
try:
    df_historial = pd.read_csv('historial.csv', encoding="utf-8", sep=";")
except FileNotFoundError:
    df_historial = pd.DataFrame(columns=["tipo_accion", "tipo_producto", "cantidad_h", "talla_h", "hora"])

import pandas as pd

def contar_registros_historial():
    # Cargar el archivo historial.csv en un DataFrame
    df = pd.read_csv("historial.csv")
    # Obtener el número total de registros (filas)
    total_registros = df.shape[0]
    return total_registros

def EliminarRegistroAntiguo():
    # Cargar el archivo CSV en un DataFrame
    df = pd.read_csv("historial.csv")
    
    # Verificar si el DataFrame tiene registros
    if not df.empty:
        # Eliminar la primera fila (el registro más antiguo)
        df = df.iloc[1:]
        
        # Guardar el DataFrame actualizado nuevamente en el archivo CSV
        df.to_csv("historial.csv", index=False)
        print("Registro más antiguo eliminado.")
    else:
        print("No hay registros para eliminar.")




def Agregar_historial(accion, producto, cantidad, talla):
    # Crear un nuevo registro
    ultima_modificacion = {
        "tipo_accion": accion,
        "tipo_producto": producto,
        "cantidad_h": cantidad,
        "talla_h": talla,
        "hora": datetime.now().strftime("%Y-%m-%d %H:%M:%S")  # Formato de fecha y hora
    }
    
    # Convertir el registro en un DataFrame
    nuevo_registro = pd.DataFrame([ultima_modificacion])
    
    # Agregar el nuevo registro al historial existente
    global df_historial
    df_historial = pd.concat([df_historial, nuevo_registro], ignore_index=True)
    
    # Guardar el DataFrame actualizado en el archivo CSV
    df_historial.to_csv('historial.csv', index=False, encoding="utf-8", sep=";")

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
            cantidad_anterior = df_productos.at[producto_idx[0], 'Cantidad_producto']
            df_productos.at[producto_idx[0], 'Cantidad_producto'] += adi_sus
            # Agregar al historial
            Agregar_historial("Agregar", tipo, f"{cantidad_anterior} -> {cantidad_anterior + adi_sus}", talla)
            if contar_registros_historial() > 20:
                EliminarRegistroAntiguo()
        elif opcion == 2:
            adi_sus = int(input("Introduzca la cantidad en que desea disminuir este producto: "))
            if adi_sus > df_productos.at[producto_idx[0], 'Cantidad_producto']:
                print("ERROR. SE DESEAN ELIMINAR MÁS INSTANCIAS DE LAS QUE HAY DISPONIBLES.")
                return
            cantidad_anterior = df_productos.at[producto_idx[0], 'Cantidad_producto']
            df_productos.at[producto_idx[0], 'Cantidad_producto'] -= adi_sus
            # Agregar al historial
            Agregar_historial("Disminuir", tipo, f"{cantidad_anterior} -> {cantidad_anterior - adi_sus}", talla)
            if contar_registros_historial() > 2:
                EliminarRegistroAntiguo()
        else:
            return

        # Guardar los cambios en el archivo CSV
        df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)
        print("Cambios guardados en el archivo CSV.")
        
    else:
        print("El producto no existe en el inventario.")

    print(df_productos.head())

def eliminar_producto():
    tipo = input("Indique el tipo del producto: ")
    colegio = input("Indique el colegio al que pertenece el producto: ")
    talla = input("Indique la talla del producto: ")

    global df_productos
    producto_idx = df_productos[
        (df_productos['Tipo_producto'] == tipo) & 
        (df_productos['Colegio_producto'] == colegio) & 
        (df_productos['Talla_producto'] == talla)
    ].index

    if not producto_idx.empty:
        cantidad = df_productos.at[producto_idx[0], 'Cantidad_producto']
        df_productos = df_productos.drop(producto_idx)
        print(f"Producto del tipo '{tipo}', colegio '{colegio}' y talla '{talla}' eliminado.")
        
        # Agregar al historial
        Agregar_historial("Eliminar", tipo, cantidad, talla)

        # Guardar los cambios en el archivo CSV
        df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)
        print("Cambios guardados en el archivo CSV.")
    else:
        print("El producto no existe en el inventario.")

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
    
    # Añadir el nuevo producto al DataFrame existente 'df_productos'
    global df_productos
    df_productos = pd.concat([df_productos, nuevo_producto_df], ignore_index=True)

    # Agregar al historial
    Agregar_historial("Agregar", nuevo_producto["Tipo_producto"], nuevo_producto["Cantidad_producto"], nuevo_producto["Talla_producto"])

    # Guardar los datos actualizados en el archivo CSV
    df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)

    print("Producto añadido exitosamente.")
    print(df_productos.head())

def menu():
    opcion = 0
    while opcion != 4:
        print("OPCIONES")
        print("1. Agregar Producto")
        print("2. Eliminar Producto")
        print("3. Modificar Producto")
        print("4. Salir")
        opcion = int(input("Seleccione una opción:  "))
    
        if opcion == 3:
            actualizar_producto()
        elif opcion == 2:
            eliminar_producto()
        elif opcion == 1:
            Agregar_producto()

menu()

