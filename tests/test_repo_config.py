import textwrap
import unittest

from scripts import repo_config


class ParseSimpleYamlTests(unittest.TestCase):
    def test_preserves_hash_characters_inside_quotes(self) -> None:
        yaml_text = textwrap.dedent(
            """
            key: "value # not a comment"
            key2: 'another # example'
            key3: plain # actual comment
            """
        )
        parsed = repo_config.parse_simple_yaml(yaml_text)
        self.assertEqual(
            parsed,
            {
                "key": "value # not a comment",
                "key2": "another # example",
                "key3": "plain",
            },
        )


if __name__ == "__main__":
    unittest.main()
