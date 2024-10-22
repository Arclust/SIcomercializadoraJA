import pandas as pd

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
        print("1. Cantidad del producto")
        print("2. Tipo de producto")
        print("3. Ambos")
        opcion = input("Seleccione una opción (1, 2, 3): ")

        if opcion == "1" or opcion == "3":
            nueva_cantidad = input("Indique la nueva cantidad del producto: ")
            df_productos.at[producto_idx[0], 'Cantidad_producto'] = nueva_cantidad
            print(f"Cantidad actualizada: {nueva_cantidad}")
        
        if opcion == "2" or opcion == "3":
            nuevo_tipo = input("Indique el nuevo tipo del producto: ")
            df_productos.at[producto_idx[0], 'Tipo_producto'] = nuevo_tipo
            print(f"Tipo de producto actualizado: {nuevo_tipo}")
        
        # Guardar los cambios en el archivo CSV
        df_productos.to_csv('InventarioPruebas.csv', sep=';', index=False)
        print("Cambios guardados en el archivo CSV.")
        
    else:
        print("El producto no existe en el inventario.")

    print(df_productos.head())

# ESTO NO ES UNA DEMOSTRACION


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
    
    # Añadir el nuevo producto al DataFrame existente 'df_productos'
    global df_productos
    df_productos = pd.concat([df_productos, nuevo_producto_df], ignore_index=True)

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