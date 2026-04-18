import 'package:flutter/material.dart';
import 'package:leyu_mobile/core/utils/screen_size.dart';
import 'package:leyu_mobile/core/widgets/loading.dart';

class TableWidget extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> values;
  final bool isDataLoading;
  final String loadingReason;
  final String noDataText;

  const TableWidget({
    super.key,
    required this.headers,
    required this.values,
    required this.isDataLoading,
    this.loadingReason = "Loading Data ...",
    this.noDataText = "No Data :(",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: values.length <= 4 ? getScreenWidth(context)-30 : values.length *(getScreenWidth(context) * 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: headers.map((header) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        header,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(thickness: 1, color: Colors.black),
            if (isDataLoading)
              Center(child: LoadingWidget(reason: loadingReason, height: 60))
            else if (values.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(noDataText),
                ),
              )
            else
              ...values.map((row) {
                return SizedBox(
                  width: values.length <= 4 ? getScreenWidth(context)-30 : values.length *(getScreenWidth(context) * 0.2),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: row.map((value) {
                        return Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 2.0,bottom: 10),
                            child: Center(child: value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

}
