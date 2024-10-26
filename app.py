import pandas as pd

# Cargar el archivo CSV
df_productos = pd.read_csv('InventarioPruebas.csv', encoding="utf-8", sep=";")

def actualizar_producto():
    tipo = input("Indique el tipo del producto: ")
    colegio = input("Indique el colegio al que pertenece el producto: ")
    talla = input("Indique la talla del producto: ")

    producto_idx = df_productos[
        (df_productos['Tipo_producto'] == tipo) &
        (df_productos['Colegio_producto'] == colegio) &
        (df_productos['Talla_producto'] == talla)
    ].index

    if not producto_idx.empty:
        accion = input("¿Quieres aumentar o reducir la cantidad? (aumentar/reducir): ").lower()

        if accion == "aumentar" or accion == "reducir":
            cantidad_cambio = int(input(f"¿Cuánto deseas {accion}?: "))

            cantidad_actual = df_productos.at[producto_idx[0], 'Cantidad_producto']
            
            if accion == "reducir":
                if cantidad_cambio > cantidad_actual:
                    print("No se puede reducir la cantidad solicitada debido a falta de stock.")
                    return  # Termina la función si no hay suficiente stock

                # Calcular la nueva cantidad y aplicar la reducción
                nueva_cantidad = cantidad_actual - cantidad_cambio
            else:
                # Calcular la nueva cantidad y aplicar el aumento
                nueva_cantidad = cantidad_actual + cantidad_cambio


            df_productos.at[producto_idx[0], 'Cantidad_producto'] = nueva_cantidad
            print(f"Producto actualizado: {tipo}, {colegio}, {talla}, Nueva cantidad: {nueva_cantidad}")

            # Aviso si la cantidad es menor a 20 unidades después de la actualización
            if nueva_cantidad < 20:
                print(f"Alerta: El producto '{tipo}' del colegio '{colegio}' y talla '{talla}' tiene pocas unidades: {nueva_cantidad}")
        else:
            print("Opción no válida. Por favor, elige 'aumentar' o 'reducir'.")
    else:
        print("El producto no existe en el inventario.")

    print(df_productos.head())


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