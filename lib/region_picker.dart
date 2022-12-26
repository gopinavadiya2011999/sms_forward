import 'package:auto_forward_sms/region.dart';
import 'package:auto_forward_sms/ui/widget/inkwell.dart';
import 'package:flutter/material.dart';

class RegionPicker extends StatefulWidget {
  final List<Region> regions;

  const RegionPicker({
    Key? key,
    required this.regions,
  }) : super(key: key);

  @override
  _RegionPickerState createState() => _RegionPickerState();
}

class _RegionPickerState extends State<RegionPicker> {
  late List<Region> _regions;
  final _ctrl = TextEditingController();

  @override
  void initState() {
    _regions = widget.regions;
    _ctrl.addListener(() {
      setState(() => _regions = _filtered(_ctrl.text));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.start,
                controller: _ctrl,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Search...',
                  border: UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _regions.length,
                  separatorBuilder: (_, i) => Divider(height: 0),
                  itemBuilder: (context, i) {
                    final region = _regions[i];
                    return inkWell(
                      onTap: () => Navigator.of(context).pop(region),
                      child: _RegionListTile(region: region),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Region> _filtered(String input) {
    return widget.regions.where(
      (elt) {
        return elt.code.toUpperCase().contains(input.toUpperCase()) ||
            elt.prefix.toString().contains(input) ||
            elt.name.toLowerCase().startsWith(input.toLowerCase());
      },
    ).toList(growable: false);
  }
}

class _RegionListTile extends StatelessWidget {
  const _RegionListTile({
    Key? key,
    required Region region,
  })  : _region = region,
        super(key: key);

  final Region _region;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.standard,
      title: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              _region.code,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(_region.name),
          Spacer(),
          Text(
            _region.prefix.isEmpty ? " " : '+${_region.prefix}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
