
    // create the 4th visual w/ groupby dynamics
        With(

            // get the total registrations first
            {
                sumRegistration: Sum(colRegistration, TotalRegistrations),
                theKeySelected: CCtablist.keyID
                
            },

            // dynamic groupby based on selected tab second

            With(

                    {
                        theTabselected: 

                        SortByColumns(
                            Switch(theKeySelected,
                                1,
                                AddColumns(
                                    GroupBy(colRegistration, Make, grpModels),
                                    totalRegistrations, Sum(grpModels, TotalRegistrations),
                                    group, Make & " (" &
                                    (
                                        Text(
                                        Sum(grpModels, TotalRegistrations)/sumRegistration * 100,
                                        "0.00%")

                                    ) & ")",
                                    
                                    subTotal, sumRegistration
                                    ),
                                2,
                                AddColumns(
                                    GroupBy(colRegistration, ModelName, Make, grpModels),
                                    totalRegistrations, Sum(grpModels, TotalRegistrations),
                                    group, Make & ";" & ModelName & " (" &
                                    (
                                        Text(
                                        Sum(grpModels, TotalRegistrations)/sumRegistration * 100,
                                        "0.00%")

                                    ) & ")",

                                    subTotal, sumRegistration
                                    )
                            ),"totalRegistrations", SortOrder.Descending
                        )
                                
                    },
                    
                // sorting here
                theTabselected
            )
        )